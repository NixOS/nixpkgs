# package.nix
{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "braa";
  version = "0.90.1";

  src = fetchFromGitHub {
    owner = "mteg";
    repo = "braa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5B5eq9HCt7WNvv5PkJnHBUaCYgs9iK63oPDyywPduxk=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 braa -t $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Mass SNMPv1/v2 scanner with its own SNMP stack, able to query thousands of hosts at once";
    homepage = "https://github.com/mteg/braa";
    changelog = "https://github.com/mteg/braa/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      sachin-sankar
      bycEEE
    ];
    platforms = lib.platforms.unix;
    mainProgram = "braa";
  };
})
