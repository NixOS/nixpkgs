{
  pkgs,
  lib,
  ...
}:
let
  testCerts =
    pkgs.runCommand "funkwhale-test-certs"
      {
        nativeBuildInputs = [ pkgs.minica ];
      }
      ''
        mkdir -p $out
        minica --domains "machine.test,pod2.test"
        mv minica.pem $out/ca.pem
        mv minica-key.pem $out/ca.key
        mv machine.test/cert.pem $out/cert.pem
        mv machine.test/key.pem $out/key.pem
      '';
in
pkgs.nixosTests.funkwhale.extend {
  modules = [
    {
      name = lib.mkForce "funkwhale-federation";

      nodes.machine =
        { lib, ... }:
        {
          networking.domain = "test";
          security.pki.certificateFiles = [ "${testCerts}/ca.pem" ];
          services.funkwhale.settings = {
            FUNKWHALE_HOSTNAME = lib.mkForce "machine.test";
            IGNORE_FORWARDED_HOST_AND_PROTO = false;
            DJANGO_ALLOWED_HOSTS = [
              "machine.test"
              "machine"
              "localhost"
              "127.0.0.1"
              "localhost:5000"
              "127.0.0.1:5000"
            ];
            EXTERNAL_REQUESTS_VERIFY_SSL = false;
          };
          services.nginx.virtualHosts."machine.test" = {
            addSSL = true;
            serverAliases = [
              "localhost"
              "localhost:5000"
            ];
            sslCertificate = "${testCerts}/cert.pem";
            sslCertificateKey = "${testCerts}/key.pem";
          };
          networking.firewall.allowedTCPPorts = [
            80
            443
          ];
        };

      nodes.pod2 =
        { pkgs, ... }:
        {
          networking.domain = "test";
          security.pki.certificateFiles = [ "${testCerts}/ca.pem" ];
          services.funkwhale = {
            enable = true;
            configureNginx = true;
            settings = {
              FUNKWHALE_HOSTNAME = "pod2.test";
              IGNORE_FORWARDED_HOST_AND_PROTO = false;
              DJANGO_ALLOWED_HOSTS = [
                "pod2.test"
                "pod2"
                "localhost"
                "127.0.0.1"
                "localhost:5000"
                "127.0.0.1:5000"
              ];
              EXTERNAL_REQUESTS_VERIFY_SSL = false;
            };
          };

          services.nginx.virtualHosts."pod2.test" = {
            addSSL = true;
            serverAliases = [
              "localhost"
              "localhost:5000"
            ];
            sslCertificate = "${testCerts}/cert.pem";
            sslCertificateKey = "${testCerts}/key.pem";
          };

          virtualisation.memorySize = 2049;
          virtualisation.diskSize = 4096;
          networking.firewall.allowedTCPPorts = [
            80
            443
          ];
          environment.systemPackages = with pkgs; [
            jq
            file
          ];
        };

      testScript = lib.mkAfter ''
        # Retrieve URLs and IDs from machine
        library_fid = machine.succeed(
            "funkwhale-manage shell -c '"
            "from funkwhale_api.music.models import Library; "
            "print(\"FID_MAGIC_\" + Library.objects.get(name=\"test_library\").fid)"
            "' | grep -oP 'FID_MAGIC_\\K.*'"
        ).strip()

        actor_fid = machine.succeed(
            "funkwhale-manage shell -c '"
            "from funkwhale_api.users.models import User; "
            "print(\"ACTOR_MAGIC_\" + User.objects.get(username=\"testinahat\").actor.fid)"
            "' | grep -oP 'ACTOR_MAGIC_\\K.*'"
        ).strip()

        machine.log(f"MACHINE LIBRARY FID: {library_fid}")
        machine.log(f"MACHINE ACTOR FID: {actor_fid}")

        # Start pod2 and wait for readiness
        pod2.wait_for_unit("funkwhale.target")
        pod2.wait_for_console_text("Listening at: http://127.0.0.1:5000")

        # Create user on pod2
        pod2.succeed(
            "funkwhale-manage fw users create --superuser "
            "--username pod2user --email pod2@example.com --password pod2password"
        )

        # 1. Test Webfinger discovery from pod2 to machine
        pod2.succeed("curl -s -f https://machine.test/.well-known/webfinger?resource=acct:testinahat@machine.test | jq .")

        # 2. Test NodeInfo discovery from pod2 to machine
        pod2.succeed("curl -s -f https://machine.test/.well-known/nodeinfo | jq .")

        # 3. Fetch remote actor from machine onto pod2
        pod2.succeed(
            f"funkwhale-manage shell -c '"
            f"from funkwhale_api.federation.actors import get_actor; "
            f"a = get_actor(\"{actor_fid}\"); "
            f"assert a.preferred_username == \"testinahat\"; "
            f"print(\"FETCHED ACTOR:\", a.fid, a.name)"
            f"'"
        )

        # 4. Fetch remote library from machine onto pod2
        pod2.succeed(
            f"funkwhale-manage shell -c '"
            f"from funkwhale_api.federation import utils, serializers; "
            f"from funkwhale_api.music.models import Library; "
            f"from funkwhale_api.users.models import User; "
            f"user = User.objects.get(username=\"pod2user\"); "
            f"lib = utils.retrieve_ap_object(\"{library_fid}\", actor=user.actor, queryset=Library.objects.all(), serializer_class=serializers.LibrarySerializer); "
            f"assert lib.name == \"test_library\"; "
            f"print(\"FETCHED LIBRARY:\", lib.uuid, lib.fid)"
            f"'"
        )

        # 5. Dispatch follow request from pod2 to machine
        pod2.succeed(
            f"funkwhale-manage shell -c '"
            f"from funkwhale_api.federation import routes, models; "
            f"from funkwhale_api.users.models import User; "
            f"from funkwhale_api.music.models import Library; "
            f"user = User.objects.get(username=\"pod2user\"); "
            f"lib = Library.objects.get(fid=\"{library_fid}\"); "
            f"follow, _ = models.LibraryFollow.objects.get_or_create(actor=user.actor, target=lib); "
            f"routes.outbox.dispatch({{\"type\": \"Follow\"}}, context={{\"follow\": follow}}); "
            f"print(\"DISPATCHED FOLLOW:\", follow.uuid)"
            f"'"
        )

        # 6. Wait for machine to receive and auto-approve the follow request
        machine.wait_until_succeeds(
            "funkwhale-manage shell -c '"
            "from funkwhale_api.federation.models import LibraryFollow; "
            "follow = LibraryFollow.objects.get(target__name=\"test_library\"); "
            "assert follow.approved is True; "
            "print(\"MACHINE APPROVED FOLLOW:\", follow.id)"
            "'"
        )

        # 7. Wait for pod2 to receive Accept activity and mark follow as approved
        pod2.wait_until_succeeds(
            f"funkwhale-manage shell -c '"
            f"from funkwhale_api.federation.models import LibraryFollow; "
            f"follow = LibraryFollow.objects.get(target__fid=\"{library_fid}\"); "
            f"assert follow.approved is True; "
            f"print(\"POD2 CONFIRMED FOLLOW:\", follow.id)"
            f"'"
        )

        # 8. Trigger library scan on pod2 to sync tracks from machine
        pod2.succeed(
            f"funkwhale-manage shell -c '"
            f"from funkwhale_api.music.models import Library; "
            f"from funkwhale_api.users.models import User; "
            f"user = User.objects.get(username=\"pod2user\"); "
            f"lib = Library.objects.get(fid=\"{library_fid}\"); "
            f"lib.schedule_scan(actor=user.actor); "
            f"print(\"SCHEDULED SCAN FOR:\", lib.name)"
            f"'"
        )

        # 9. Verify track Test Music appears in pod2 database
        pod2.wait_until_succeeds(
            "funkwhale-manage shell -c '"
            "from funkwhale_api.music.models import Track; "
            "assert Track.objects.filter(title=\"Test Music\").exists(); "
            "print(\"POD2 SYNCED TRACK:\", Track.objects.get(title=\"Test Music\").title)"
            "'"
        )

        # 10. Verify remote track playback/stream from pod2
        pod2_track_uuid = pod2.succeed(
            "funkwhale-manage shell -c '"
            "from funkwhale_api.music.models import Track; "
            "print(\"POD2_TRACK_\" + str(Track.objects.get(title=\"Test Music\").uuid))"
            "' | grep -oP 'POD2_TRACK_\\K.*'"
        ).strip()

        pod2_token = pod2.succeed(
            "funkwhale-manage shell -c '"
            "from datetime import timedelta; "
            "from django.utils import timezone; "
            "from funkwhale_api.users.models import User, AccessToken, Application; "
            "user = User.objects.get(username=\"pod2user\"); "
            "app = Application.objects.create(name=\"test2\", client_type=\"confidential\", authorization_grant_type=\"password\", user=user, scope=\"read:libraries\"); "
            "token = AccessToken.objects.create(user=user, application=app, token=\"pod2_test_token_12345\", expires=timezone.now() + timedelta(days=1), scope=\"read:libraries\"); "
            "print(\"TOKEN_MAGIC_\" + token.token)"
            "' | grep -oP 'TOKEN_MAGIC_\\K.*'"
        ).strip()

        pod2.succeed(
            f"curl -s -f -H 'Authorization: Bearer {pod2_token}' https://pod2.test/api/v2/listen/{pod2_track_uuid}/?to=mp3 --output /tmp/federated.mp3"
        )
        pod2.succeed("file /tmp/federated.mp3 | grep -i 'Audio file with ID3'")
      '';
    }
  ];
}
