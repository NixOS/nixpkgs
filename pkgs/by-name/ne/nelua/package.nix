{
  lib,
  stdenv,
  fetchFromGitHub,
  luaPackages,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nelua";
  version = "0-unstable-2025-06-24";

  src = fetchFromGitHub {
    owner = "edubart";
    repo = "nelua-lang";
    rev = "a58450563e2d2ec49bff499865c8b5cfdf6ff81a";
    hash = "sha256-JBARpQXqQ7bMt+Za28v3c5fFvUdT4JgMq/C33HTnJCk=";
  };

  postPatch = ''
    substituteInPlace lualib/nelua/version.lua \
      --replace "NELUA_GIT_HASH = nil" "NELUA_GIT_HASH = '${finalAttrs.src.rev}'" \
      --replace "NELUA_GIT_DATE = nil" "NELUA_GIT_DATE = '${lib.removePrefix "0-unstable-" finalAttrs.version}'"
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  nativeCheckInputs = [ luaPackages.luacheck ];

  doCheck = true;

  passthru.updateScript = unstableGitUpdater {
    # no releases, only stale "latest" tag
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Minimal, efficient, statically-typed and meta-programmable systems programming language heavily inspired by Lua, which compiles to C and native code";
    homepage = "https://nelua.io/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
