{
  libressl,
}:

libressl.nc.overrideAttrs {
  meta = {
    description = "Utility which reads and writes data across network connections — LibreSSL implementation";
    mainProgram = "nc";
  };
}
