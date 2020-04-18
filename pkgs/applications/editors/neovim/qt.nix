{ stdenv, mkDerivation, fetchFromGitHub, cmake, doxygen, makeWrapper
, msgpack, neovim, pythonPackages, qtbase }:

let
  unwrapped = mkDerivation rec {
    pname = "neovim-qt-unwrapped";
    version = "0.2.15";

    src = fetchFromGitHub {
      owner  = "equalsraf";
      repo   = "neovim-qt";
      rev    = "v${version}";
      sha256 = "097nykglqp4jyvla4yp32sc1f1hph4cqqhp6rm9ww7br8c0j54xl";
    };

    cmakeFlags = [
      "-DUSE_SYSTEM_MSGPACK=1"
    ];

    buildInputs = [
      neovim.unwrapped # only used to generate help tags at build time
      qtbase
    ] ++ (with pythonPackages; [
      jinja2 python msgpack
    ]);

    nativeBuildInputs = [ cmake doxygen ];

    enableParallelBuilding = true;

    preCheck = ''
      # The GUI tests require a running X server, disable them
      sed -i ../test/CMakeLists.txt \
        -e '/^add_xtest_gui/d'
    '';

    doCheck = true;

    meta = with stdenv.lib; {
      description = "Neovim client library and GUI, in Qt5";
      license     = licenses.isc;
      maintainers = with maintainers; [ peterhoeg ];
      inherit (neovim.meta) platforms;
      inherit version;
    };
  };
in
  stdenv.mkDerivation {
    pname = "neovim-qt";
    version = unwrapped.version;
    buildCommand = if stdenv.isDarwin then ''
      mkdir -p $out/Applications
      cp -r ${unwrapped}/bin/nvim-qt.app $out/Applications

      chmod -R a+w "$out/Applications/nvim-qt.app/Contents/MacOS"
      wrapProgram "$out/Applications/nvim-qt.app/Contents/MacOS/nvim-qt" \
        --prefix PATH : "${neovim}/bin"
    '' else ''
      makeWrapper '${unwrapped}/bin/nvim-qt' "$out/bin/nvim-qt" \
        --prefix PATH : "${neovim}/bin"

      # link .desktop file
      mkdir -p "$out/share/pixmaps"
      ln -s '${unwrapped}/share/applications' "$out/share/applications"
      ln -s '${unwrapped}/share/pixmaps/nvim-qt.png' "$out/share/pixmaps/nvim-qt.png"
    '';

    preferLocalBuild = true;

    nativeBuildInputs = [
      makeWrapper
    ];

    passthru = {
      inherit unwrapped;
    };

    inherit (unwrapped) meta;
  }
