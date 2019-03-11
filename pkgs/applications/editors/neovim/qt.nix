{ stdenv, fetchFromGitHub, cmake, doxygen, makeWrapper
, msgpack, neovim, pythonPackages, qtbase }:

let
  unwrapped = stdenv.mkDerivation rec {
    pname = "neovim-qt-unwrapped";
    version = "0.2.11";

    src = fetchFromGitHub {
      owner  = "equalsraf";
      repo   = "neovim-qt";
      rev    = "v${version}";
      sha256 = "0pc1adxc89p2rdvb6nxyqr9sjzqz9zw2dg7a4ardxsl3a8jga1wh";
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

    nativeBuildInputs = [ cmake doxygen makeWrapper ];

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
      mkdir -p "$out/share"
      ln -s '${unwrapped}/share/applications' "$out/share/applications"
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
