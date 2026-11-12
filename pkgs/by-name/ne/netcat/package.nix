{
  lib,
  libressl,
}:

lib.addMetaAttrs {
  description = "Utility which reads and writes data across network connections — LibreSSL implementation";
  mainProgram = "nc";
} libressl.nc
