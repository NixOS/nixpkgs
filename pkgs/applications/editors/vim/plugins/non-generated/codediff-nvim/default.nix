{
  lib,
  cmake,
  codediff-watcher,
  fetchFromGitHub,
  nix-update-script,
  vimUtils,
  vimPlugins,
  autoPatchelfHook,
  stdenv,
  llvmPackages,
}:
vimUtils.buildVimPlugin rec {
  pname = "codediff.nvim";
  version = "4.0.8";

  src = fetchFromGitHub {
    owner = "esmuellert";
    repo = "codediff.nvim";
    tag = "v${version}";
    hash = "sha256-hzeMFNrptA3MO1htsQtcASla9zaoC8r2KKpwQvCuRMw=";
  };

  dependencies = [ vimPlugins.nui-nvim ];

  nativeBuildInputs = [ cmake ] ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ llvmPackages.openmp ];
  dontUseCmakeConfigure = true;

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace libvscode-diff/CMakeLists.txt \
      --replace-fail 'COMMAND brew --prefix libomp' 'COMMAND echo ${llvmPackages.openmp}'
  '';

  buildPhase = ''
    runHook preBuild
    make
    runHook postBuild
  '';

  # Cleanup
  preInstall = ''
    rm -rf build
  '';

  # The plugin looks for the watcher in its root before downloading it at runtime.
  postInstall = ''
    ln -s ${lib.getExe codediff-watcher} $out/codediff-watcher
  ''
  # The plugin detects Nix and tries to download libgomp at runtime.
  # Symlinking it into the plugin directory fixes error message.
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    ln -s ${stdenv.cc.cc.lib}/lib/libgomp.so.1 $out/libgomp.so.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "VSCode-style side-by-side diff rendering with two-tier highlighting (line + character level)";
    homepage = "https://github.com/esmuellert/codediff.nvim/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
