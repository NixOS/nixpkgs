{ mkDerivation
, lib
, fetchFromGitHub
, qmake
, pkg-config
, qtbase
, qtsvg
, qttools
, qtserialport
, boost
, libgit2
}:

let
  # build number corresponding to a release, has no further relation
  # see https://github.com/fritzing/fritzing-app/releases/tag/CD-498
  # fritzingBuild = "498";
  # version 0.9.6 is properly tagged, hope it continues

  # SHA256 of the fritzing-parts HEAD on the master branch,
  # which contains the latest stable parts definitions
  partsSha = "6f04697be286768bc9e4d64f8707e8e40cbcafcb";
in

mkDerivation rec {
  pname = "fritzing";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = "fritzing-app";
    rev = version;
    sha256 = "083nz7vj7a334575smjry6257535h68gglh8a381xxa36dw96aqs";
  };

  parts = fetchFromGitHub {
    owner = pname;
    repo = "fritzing-parts";
    name = "fritzing-parts";
    rev = partsSha;
    sha256 = "1f4w0hz44n4iw1rc5vhcgzvlji54rf4yr8bvzkqv99hn2xf5pjgs";
  };

  buildInputs = [ qtbase qtsvg qtserialport boost libgit2 ];
  nativeBuildInputs = [ qmake pkg-config qttools ];

  postPatch = ''
    substituteInPlace phoenix.pro \
      --replace 'LIBGIT_STATIC = true' 'LIBGIT_STATIC = false'

    substituteInPlace src/fapplication.cpp \
      --replace 'PartsChecker::getSha(dir.absolutePath());' '"${partsSha}";'

    mkdir parts
    cp -a ${parts}/* parts/
  '';

  postFixup = ''
    # generate the parts.db file
    QT_QPA_PLATFORM=offscreen "$out/bin/Fritzing" \
      -db "$out/share/fritzing/parts/parts.db" \
      -pp "$out/fritzing/parts" \
      -folder "$out/share/fritzing"
  '';

  qmakeFlags = [ "phoenix.pro" ];

  meta = with lib; {
    description = "An open source prototyping tool for Arduino-based projects";
    homepage = "https://fritzing.org/";
    license = with licenses; [ gpl3 cc-by-sa-30 ];
    maintainers = with maintainers; [ robberer ];
    platforms = platforms.linux;
  };
}
