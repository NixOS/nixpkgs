{
  fetchFromGitHub,
  stdenv,
  lib,
  python3,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ac-library";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "atcoder";
    repo = "ac-library";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-AIqG98c1tcxxhYcX+NSf6Rw3onw61T5NTZtqQzT9jls=";
  };

  outputs = [
    "dev"
    "out"
  ];

  buildInputs = [
    python3
  ];

  installPhase = ''
    runHook preInstall

    install -d $dev/include/atcoder
    install -m644 atcoder/* $dev/include/atcoder/
    install -Dm755 expander.py $out/bin/expander

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Official library of AtCoder";
    homepage = "https://github.com/atcoder/ac-library";
    license = lib.licenses.cc0;
    changelog = "https://github.com/atcoder/ac-library/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = lib.platforms.all;
  };
})
