{ mkDerivation, stdenv, fetchpatch, fetchFromGitHub, qmake, pkgconfig
, qtbase, qtsvg, qttools, qtserialport, boost, libgit2
}:

let
  # build number corresponding to a release, has no further relation
  # see https://github.com/fritzing/fritzing-app/releases/tag/CD-498
  fritzingBuild = "498";
  # SHA256 of the fritzing-parts HEAD on the master branch,
  # which contains the latest stable parts definitions
  partsSha = "e79a69765026f3fda8aab1b3e7a4952c28047a62";
in

mkDerivation rec {
  pname = "fritzing";
  version = "0.9.4-${fritzingBuild}";

  src = fetchFromGitHub {
    owner = "fritzing";
    repo = "fritzing-app";
    rev = "CD-${fritzingBuild}";
    sha256 = "0aljj2wbmm1vd64nhj6lh9qy856pd5avlgydsznya2vylyz20p34";
  };

  parts = fetchFromGitHub {
    owner = "fritzing";
    repo = "fritzing-parts";
    name = "fritzing-parts";
    rev = partsSha;
    sha256 = "0spka33a5qq34aq79j01arw1aly4vh0hzv7mahryhdlcdk22qqvc";
  };

  buildInputs = [ qtbase qtsvg qtserialport boost libgit2 ];

  nativeBuildInputs = [ qmake pkgconfig qttools ];

  patches = [(fetchpatch {
    name = "fix-libgit2-version.patch";
    url = "https://github.com/fritzing/fritzing-app/commit/472951243d70eeb40a53b1f7e16e6eab0588d079.patch";
    sha256 = "0v1zi609cjnqac80xgnk23n54z08g1lia37hbzfl8jcq9sn9adak";
  })];

  postPatch = ''
    substituteInPlace phoenix.pro \
      --replace 'LIBGIT_STATIC = true' 'LIBGIT_STATIC = false'

    substituteInPlace tools/linux_release_script/release.sh \
      --replace 'git status' 'echo >/dev/null' \
      --replace 'git clean' 'echo >/dev/null' \
      --replace 'git clone' 'echo >/dev/null' \
      --replace 'release_folder="' 'release_folder="$out" #' \
      --replace './Fritzing -db' '# run after fixup'

    substituteInPlace src/fapplication.cpp \
      --replace 'PartsChecker::getSha(dir.absolutePath());' '"${partsSha}";'
  '';

  buildPhase = ''
    bash tools/linux_release_script/release.sh ${version}
  '';

  installPhase = ''
    rm "$out/Fritzing" # remove script file
    mkdir "$out/bin"
    mv "$out/lib/Fritzing" "$out/bin/Fritzing"
    mkdir --parents "$out/share/applications" "$out/share/metainfo"
    mv --target-directory="$out/share/applications" "$out/org.fritzing.Fritzing.desktop"
    mv --target-directory="$out/share/metainfo" "$out/org.fritzing.Fritzing.appdata.xml"
    cp --recursive --no-target-directory "$parts" "$out/fritzing-parts"
  '';

  postFixup = ''
    # generate the parts.db file
    QT_QPA_PLATFORM=offscreen "$out/bin/Fritzing" -db "$out/fritzing-parts/parts.db" -pp "$out/fritzing-parts" -folder "$out"
  '';

  qmakeFlags = [ "phoenix.pro" ];

  meta = {
    description = "An open source prototyping tool for Arduino-based projects";
    homepage = "http://fritzing.org/";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.robberer ];
    platforms = stdenv.lib.platforms.linux;
  };
}
