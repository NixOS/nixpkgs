{ lib
, mkDerivation
, fetchFromGitHub
, fetchFromSourcehut
, cmake
, extra-cmake-modules
, pkg-config
, kirigami2
, libdeltachat
, qtbase
, qtimageformats
, qtmultimedia
, qtwebengine
, rustPlatform
}:

let
  libdeltachat' = libdeltachat.overrideAttrs (old: rec {
    inherit (old) pname;
    version = "1.58.0";
    src = fetchFromGitHub {
      owner = "deltachat";
      repo = "deltachat-core-rust";
      rev = version;
      sha256 = "03xc0jlfmvmdcipmzavbzkq010qlxzf3mj1zi7wcix7kpl8gwmy7";
    };
    cargoDeps = rustPlatform.fetchCargoTarball {
      inherit src;
      name = "${pname}-${version}";
      sha256 = "1zijxyc1xjlbyh1gh2lyw44xjcrhz1msykrlqgfkw5w1w0yh78hd";
    };
  });
in mkDerivation rec {
  pname = "kdeltachat";
  version = "unstable-2021-08-02";

  src = fetchFromSourcehut {
    owner = "~link2xt";
    repo = "kdeltachat";
    rev = "950f4f22c01ab75f613479ef831bdf38f395d1dd";
    sha256 = "007gazqkzcc0w0rq2i8ysa9f50ldj7n9f5gp1mh8bi86bdvdkzsy";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    kirigami2
    libdeltachat'
    qtimageformats
    qtmultimedia
    qtwebengine
  ];

  # needed for qmlplugindump to work
  QT_PLUGIN_PATH = "${qtbase.bin}/${qtbase.qtPluginPrefix}";
  QML2_IMPORT_PATH = lib.concatMapStringsSep ":"
    (lib: "${lib}/${qtbase.qtQmlPrefix}")
    [ kirigami2 qtmultimedia ];

  meta = with lib; {
    description = "Delta Chat client using Kirigami framework";
    homepage = "https://git.sr.ht/~link2xt/kdeltachat";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.linux;
  };
}
