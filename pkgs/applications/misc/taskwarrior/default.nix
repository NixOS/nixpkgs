{ lib
, stdenv
, fetchFromGitHub
, cmake
, libuuid
, gnutls
, rustPlatform
, python3
, xdg-utils
, installShellFiles
}:

rustPlatform.buildRustPackage rec {

  pname = "taskwarrior";

  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "taskwarrior";
    rev = "v${version}";
    sha256 = "sha256-vN3X6vLuD4Fw9wpEUYLf8sboA5GIcdP5EFb41KS6d5s=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-KJ2h/fTZFTu5P/N9W8maOiqGGEMqAzvVRkoB9ncdJxc=";

  postPatch = ''
    substituteInPlace src/commands/CmdNews.cpp \
      --replace "xdg-open" "${lib.getBin xdg-utils}/bin/xdg-open"
  '';

  nativeBuildInputs = [ cmake gnutls python3 installShellFiles ];

  buildInputs = [ libuuid ];

  configurePhase = ''
    runHook preConfigure
    cmake -S . -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    cmake --build build -j $NIX_BUILD_CORES
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    cmake --install build --prefix $out
    runHook postInstall
  '';

  doCheck = true;

  preCheck = ''
    patchShebangs --build test
  '';

  checkTarget = "test";

  checkPhase = ''
    runHook preCheck
    cmake --build build --target build_tests -j $NIX_BUILD_CORES
    ctest --test-dir build -j $NIX_BUILD_CORES
    runHook postCheck
  '';

  postInstall = ''
    # ZSH is installed automatically from some reason, only bash and fish need
    # manual installation
    installShellCompletion --cmd task \
      --bash $out/share/doc/task/scripts/bash/task.sh \
      --fish $out/share/doc/task/scripts/fish/task.fish
    rm -r $out/share/doc/task/scripts/bash
    rm -r $out/share/doc/task/scripts/fish
    # Install vim and neovim plugin
    mkdir -p $out/share/vim-plugins
    mv $out/share/doc/task/scripts/vim $out/share/vim-plugins/task
    mkdir -p $out/share/nvim
    ln -s $out/share/vim-plugins/task $out/share/nvim/site
  '';

  meta = with lib; {
    description = "Highly flexible command-line tool to manage TODO lists";
    homepage = "https://taskwarrior.org";
    license = licenses.mit;
    maintainers = with maintainers; [ marcweber oxalica ];
    mainProgram = "task";
    platforms = platforms.unix;
  };
}
