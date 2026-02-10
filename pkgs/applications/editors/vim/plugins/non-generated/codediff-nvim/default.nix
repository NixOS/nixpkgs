{
  lib,
  cmake,
  fetchFromGitHub,
  nix-update-script,
  vimUtils,
  vimPlugins,
  autoPatchelfHook,
  stdenv,
}:
vimUtils.buildVimPlugin rec {
  pname = "codediff.nvim";
  version = "2.19.0";

  src = fetchFromGitHub {
    owner = "esmuellert";
    repo = "codediff.nvim";
    tag = "v${version}";
    hash = "sha256-l8bP8NNCoE7SLRMRh+Nq5OxUD+xdJ2qYyWbA140aFV0=";
  };

  dependencies = [ vimPlugins.nui-nvim ];

  nativeBuildInputs = [ cmake ] ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];
  dontUseCmakeConfigure = true;
  buildPhase = ''
    runHook preBuild
    make
    runHook postBuild
  '';

  # The plugin detects Nix and tries to download libgomp at runtime.
  # Symlinking it into the plugin directory fixes error message.
  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
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
