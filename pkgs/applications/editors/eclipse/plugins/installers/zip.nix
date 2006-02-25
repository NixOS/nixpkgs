{stdenv, unzip, plugin}:

let {
  body =
    stdenv.mkDerivation {
      name = "eclipse-zip-plugin-installer";
      builder = ./builder.sh;
      inherit plugin unzip;
   };
}