{
  lib,
  lua,
  melpaBuild,
  pkg-config,
  fetchFromGitHub,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "lua";
  version = "0-unstable-2025-01-27";

  src = fetchFromGitHub {
    owner = "syohex";
    repo = "emacs-lua";
    rev = "501189b5fc069fcead8843b2b0ad510c08de1397";
    hash = "sha256-psCrto12p03R9XxPtDYTMB5vcRVWj+Blq7D30nLsSbU=";
  };

  preBuild = ''
    make LUA_VERSION=${lua.luaversion} CC=$CC LD=$CC
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ lua ];

  files = ''(:defaults "lua-core.so")'';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/syohex/emacs-lua";
    description = "Lua engine from Emacs Lisp";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nagy ];
  };
}
