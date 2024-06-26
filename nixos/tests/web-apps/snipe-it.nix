/*
  Snipe-IT NixOS test

  It covers the following scenario:
  - Installation
  - Backup and restore

  Scenarios NOT covered by this test (but perhaps in the future):
  - Sending and receiving emails
*/
{ pkgs, ... }:
let
  siteName = "NixOS Snipe-IT Test Instance";
in
{
  name = "snipe-it";

  meta.maintainers = with pkgs.lib.maintainers; [ yayayayaka ];

  nodes = {
    snipeit =
      { ... }:
      {
        services.snipe-it = {
          enable = true;
          appKeyFile = toString (
            pkgs.writeText "snipe-it-app-key" "uTqGUN5GUmUrh/zSAYmhyzRk62pnpXICyXv9eeITI8k="
          );
          hostName = "localhost";
          database.createLocally = true;
          mail = {
            driver = "smtp";
            encryption = "tls";
            host = "localhost";
            port = 1025;
            from.name = "Snipe-IT NixOS test";
            from.address = "snipe-it@localhost";
            replyTo.address = "snipe-it@localhost";
            user = "snipe-it@localhost";
            passwordFile = toString (pkgs.writeText "snipe-it-mail-pass" "a-secure-mail-password");
          };
        };
      };
  };

  testScript =
    { nodes }:
    let
      backupPath = "${nodes.snipeit.services.snipe-it.dataDir}/storage/app/backups";

      # Snipe-IT has been installed successfully if the site name shows up on the login page
      checkLoginPage =
        {
          shouldSucceed ? true,
        }:
        ''
          snipeit.${
            if shouldSucceed then "succeed" else "fail"
          }("""curl http://localhost/login | grep '${siteName}'""")
        '';
    in
    ''
      start_all()

      snipeit.wait_for_unit("nginx.service")
      snipeit.wait_for_unit("snipe-it-setup.service")

      # Create an admin user
      snipeit.succeed(
          """
          snipe-it snipeit:create-admin \
              --username="admin" \
              --email="janedoe@localhost" \
              --password="extremesecurepassword" \
              --first_name="Jane" \
              --last_name="Doe"
          """
      )

      with subtest("Circumvent the pre-flight setup by just writing some settings into the database ourself"):
          snipeit.succeed(
              """
              mysql -D ${nodes.snipeit.services.snipe-it.database.name} -e "INSERT INTO settings (id, user_id, site_name) VALUES ('1', '1', '${siteName}');"
              """
          )

          # Usually these are generated during the pre-flight setup
          snipeit.succeed("snipe-it passport:keys")


      # Login page should now contain the configured site name
      ${checkLoginPage { }}

      with subtest("Test Backup and restore"):
          snipeit.succeed("snipe-it snipeit:backup")

          # One zip file should have been created
          snipeit.succeed("""[ "$(ls -1 "${backupPath}" | wc -l)" -eq 1 ]""")

          # Purge the state
          snipeit.succeed("snipe-it migrate:fresh --force")

          # Login page should disappear
          ${checkLoginPage { shouldSucceed = false; }}

          # Restore the state
          snipeit.succeed(
              """
              snipe-it snipeit:restore --force $(find "${backupPath}/" -type f -name "*.zip")
              """
          )

          # Login page should be back again
          ${checkLoginPage { }}
    '';
}
