{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libevent,
  file,
  qrencode,
  miniupnpc,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pshs";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "mgorny";
    repo = "pshs";
    rev = "v${finalAttrs.version}";
    sha256 = "1j8j4r0vsmp6226q6jdgf9bzhx3qk7vdliwaw7f8kcsrkndkg6p4";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libevent
    file
    qrencode
    miniupnpc
  ];

  strictDeps = true;

  # SSL requires libevent at 2.1 with ssl support
  configureFlags = [ "--disable-ssl" ];

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pretty small HTTP server - a command-line tool to share files";
    mainProgram = "pshs";
    homepage = "https://github.com/mgorny/pshs";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
