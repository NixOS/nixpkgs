lib : with (import ./param-constructors.nix lib);

let mkJournalParam = description :
      mkEnumParam [(-1) 0 1 2 3 4] 0 "Logging level for ${description}";
in {
  default = mkIntParam 1 ''
    Specifies the default loglevel to be used for subsystems for which no
    specific loglevel is defined.
  '';

  app = mkJournalParam "applications other than daemons.";
  asn = mkJournalParam "low-level encoding/decoding (ASN.1, X.509 etc.)";
  cfg = mkJournalParam "configuration management and plugins.";
  chd = mkJournalParam "CHILD_SA/IPsec SA.";
  dmn = mkJournalParam "main daemon setup/cleanup/signal handling.";
  enc = mkJournalParam "packet encoding/decoding encryption/decryption operations.";
  esp = mkJournalParam "libipsec library messages.";
  ike = mkJournalParam "IKE_SA/ISAKMP SA.";
  imc = mkJournalParam "integrity Measurement Collector.";
  imv = mkJournalParam "integrity Measurement Verifier.";
  job = mkJournalParam "jobs queuing/processing and thread pool management.";
  knl = mkJournalParam "IPsec/Networking kernel interface.";
  lib = mkJournalParam "libstrongwan library messages.";
  mgr = mkJournalParam "IKE_SA manager, handling synchronization for IKE_SA access.";
  net = mkJournalParam "IKE network communication.";
  pts = mkJournalParam "platform Trust Service.";
  tls = mkJournalParam "libtls library messages.";
  tnc = mkJournalParam "trusted Network Connect.";
}
