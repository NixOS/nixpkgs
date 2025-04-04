{
  lib,
  stdenv,
  fetchurl,
  unzip,
  ...
}:

stdenv.mkDerivation rec {
  pname = "scriptaculous";
  version = "1.9.0";

  src = fetchurl {
    url = "https://script.aculo.us/dist/scriptaculous-js-${version}.zip";
    sha256 = "1xpnk3cq8n07lxd69k5jxh48s21zh41ihq10z4a6lcnk238rp8qz";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir $out
    cp src/*.js $out
  '';

  meta = with lib; {
    description = "Set of JavaScript libraries to enhance the user interface of web sites";
    longDescription = ''
      script.aculo.us provides you with
      easy-to-use, cross-browser user
      interface JavaScript libraries to make
      your web sites and web applications fly.
    '';
    homepage = "https://script.aculo.us/";
    downloadPage = "https://script.aculo.us/dist/";
    license = licenses.mit;
    maintainers = with maintainers; [ das_j ];
  };
}
