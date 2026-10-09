{
  lib,
  stdenv,
  fetchFromSourcehut,
  nix-update-script,
  versionCheckHook,
  lua5_5,
  # the version of lua to use for the compiler
  luaVersion ? lua5_5,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fennel";
  version = "1.6.1";

  src = fetchFromSourcehut {
    owner = "~technomancy";
    repo = "fennel";
    tag = finalAttrs.version;
    hash = "sha256-MLXLkRKlxqvEOogM5I4uHxnlRLjK8Pbeq9b1+kAgqFg=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  buildInputs = [
    luaVersion
  ];

  makeFlags = [
    "LUA=${luaVersion}/bin/lua"
    "PREFIX=$(out)"
  ];

  doCheck = true;
  preCheck = ''
    rm test/irc.lua
    # don't report test failures to the fennel irc
    substituteInPlace test/init.lua \
      --replace-fail ',{hooks={exit=dofile("test/irc.lua")}}' ""

    # this test currently fails on lua 5.5
    # technomancy said it should just be disabled here
    # until it's fixed upstream
    substituteInPlace test/fennelview.fnl \
      --replace-fail '(t.= "1.4179134365423e+14" (view (fennel.eval "1.4179134365423e+14")))' ""
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A lisp that compiles to Lua";
    homepage = "https://fennel-lang.org/";
    changelog = "https://fennel-lang.org/changelog";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      misterio77
      emily-lavender
    ];
    mainProgram = "fennel";
  };
})
