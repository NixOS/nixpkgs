{ lib, ... }:
{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "journalbeat" "enable" ]
      "'services.journalbeat' has been removed; journalbeat was deprecated upstream in 7.15 and removed in 8.0. Use 'services.filebeat' with the journald input instead."
    )
  ];
}
