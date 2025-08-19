let
  clients = [
    "ircclient1"
    "ircclient2"
  ];
  server = "inspircd";
  ircPort = 6667;
  channel = "nixos-cat";
  iiDir = "/tmp/irc";
in

{ pkgs, lib, ... }:
{
  name = "inspircd";
  nodes = {
    "${server}" = {
      networking.firewall.allowedTCPPorts = [ ircPort ];
      services.inspircd = {
        enable = true;
        package = pkgs.inspircdMinimal;
        config = ''
          <bind address="" port="${toString ircPort}" type="clients">
          <connect name="main" allow="*" pingfreq="15">
        '';
      };
    };
  }
  // lib.listToAttrs (
    builtins.map (
      client:
      lib.nameValuePair client {
        imports = [
          ./common/user-account.nix
        ];

        systemd.services.ii = {
          requires = [ "network.target" ];
          wantedBy = [ "default.target" ];

          serviceConfig = {
            Type = "simple";
            ExecPreStartPre = "mkdir -p ${iiDir}";
            ExecStart = ''
              ${lib.getBin pkgs.ii}/bin/ii -n ${client} -s ${server} -i ${iiDir}
            '';
            User = "alice";
          };
        };
      }
    ) clients
  );

  testScript =
    let
      msg = client: "Hello, my name is ${client}";
      clientScript =
        client:
        [
          ''
            ${client}.wait_for_unit("network.target")
            ${client}.systemctl("start ii")
            ${client}.wait_for_unit("ii")
            ${client}.wait_for_file("${iiDir}/${server}/out")
          ''
          # wait until first PING from server arrives before joining,
          # so we don't try it too early
          ''
            ${client}.wait_until_succeeds("grep 'PING' ${iiDir}/${server}/out")
          ''
          # join ${channel}
          ''
            ${client}.succeed("echo '/j #${channel}' > ${iiDir}/${server}/in")
            ${client}.wait_for_file("${iiDir}/${server}/#${channel}/in")
          ''
          # send a greeting
          ''
            ${client}.succeed(
                "echo '${msg client}' > ${iiDir}/${server}/#${channel}/in"
            )
          ''
          # check that all greetings arrived on all clients
        ]
        ++ builtins.map (other: ''
          ${client}.succeed(
              "grep '${msg other}$' ${iiDir}/${server}/#${channel}/out"
          )
        '') clients;

      # foldl', but requires a non-empty list instead of a start value
      reduce = f: list: builtins.foldl' f (builtins.head list) (builtins.tail list);
    in
    ''
      start_all()
      ${server}.wait_for_open_port(${toString ircPort})

      # run clientScript for all clients so that every list
      # entry is executed by every client before advancing
      # to the next one.
    ''
    + lib.concatStrings (reduce (lib.zipListsWith (cs: c: cs + c)) (builtins.map clientScript clients));
}
