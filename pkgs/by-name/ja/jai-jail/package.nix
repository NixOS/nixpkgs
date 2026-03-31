{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  pandoc,
  util-linux,
  acl,
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "jai";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "stanford-scs";
    repo = "jai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BMgWodfo5l/PKOniEYHrUSQJIr3t8BzdLhw9nU0qbOw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    pandoc
  ];

  buildInputs = [
    util-linux # libmount
    acl
  ];

  configureFlags = [ "--with-untrusted-user=jai" ];

  meta = {
    description = "Lightweight jail for AI CLIs";
    mainProgram = "jai";
    homepage = "https://jai.scs.stanford.edu";
    changelog = "https://github.com/stanford-scs/jai/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ agentelement ];
    platforms = lib.platforms.linux;
  };
})
