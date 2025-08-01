{
  fetchFromGitHub,
  rustPlatform,
  lib,
  versionCheckHook,
  writeShellScript,
  lua,
}:
let
  version = "0.7.1";
in
rustPlatform.buildRustPackage {
  pname = "lovely-injector";
  inherit version;
  src = fetchFromGitHub {
    owner = "ethangreen-dev";
    repo = "lovely-injector";
    tag = "v${version}";
    hash = "sha256-j03/DOnLFfFYTwGGh+7BalS779jyg+p0UqtcTTyHgv4=";
  };

  cargoHash = "sha256-hHq26kSKcqEldxUb6bn1laTpKGFplP9/2uogsal8T5A=";
  # no tests
  doCheck = false;
  # lovely-injector depends on nightly rust features
  env.RUSTC_BOOTSTRAP = 1;
  nativeBuildInputs = [
    lua
  ];
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = [ "${placeholder "out"}" ];
  versionCheckProgram = writeShellScript "lovely-version-check" ''
    export LD_PRELOAD="$1/lib/liblovely.so"
    exec ${lua}/bin/lua < /dev/null
  '';

  meta = {
    description = "Runtime lua injector for games built with LÖVE";
    longDescription = ''
      Lovely is a lua injector which embeds code into a LÖVE 2d game at runtime.
      Unlike executable patchers, mods can be installed, updated, and removed over and over again without requiring a partial or total game reinstallation.
      This is accomplished through in-process lua API detouring and an easy to use (and distribute) patch system.
    '';
    license = lib.licenses.mit;
    homepage = "https://github.com/ethangreen-dev/lovely-injector";
    downloadPage = "https://github.com/ethangreen-dev/lovely-injector/releases";
    maintainers = [ lib.maintainers.antipatico ];
    platforms = [ "x86_64-linux" ];
  };
}
