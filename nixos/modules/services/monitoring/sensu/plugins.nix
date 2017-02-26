{ lib }:

{
  options = with lib; with types; {

    mailer = mkOption {
      description = "sensu-plugins-mailer";
      default = {};
      type = submodule {
        options = {
          mail_from = mkOption {
            type = str;
            description = "Sender";
          };

          mail_to = mkOption {
            type = str;
            description = "Recipient";
          };
        };
      };
    };
  };
}





#     type = mkOption {
#       type = enum [ "pipe" "tcp" "udp" "transport" "set" ];
#       description = "Type of handler.";
#     };

#     filters = mkOption {
#       type = listOf str;
#       default = [];
#       description = "List of filters.";
#     };

#     severities = mkOption {
#       type = listOf (enum [ "warning" "critical" "unknown" ]);
#       default = [ "unknown" ];
#       description = "Severities to handle.";
#     };

#     subscribers = mkOption {
#       type = listOf str;
#       default = [];
#       description = "Subscribers";
#     };

#     timeout = mkOption {
#       type = int;
#       default = 30;
#       description = "Timeout.";
#     };

#     command = mkOption {
#       type = str;
#       default = "";
#       description = "Command for type pipe.";
#     };

#     socket = mkOption {
#       type = attrs;
#       default = {};
#       description = "Socket for type tcp or udp.";
#     };

#     pipe = mkOption {
#       type = attrs;
#       default = {};
#       description = "Pipe for type pipe.";
#     };

#     handlers = mkOption {
#       type = listOf str;
#       default = [];
#       description = "Handlers for type set.";
#     };
#   };
# }
