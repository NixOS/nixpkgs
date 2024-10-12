{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation {
  pname = "misc-gitology";
  version = "unstable-2023-06-22";

  src = fetchFromGitHub {
    owner = "da-x";
    repo = "misc-gitology";
    rev = "a867f81b896615e01ec751996b607153a9ef8a0e";
    hash = "sha256-UdHSQk1esoc27QJYjQbNeTbWtWMipahERNC197Tai3o=";
  };
  phases = "unpackPhase installPhase fixupPhase installCheckPhase";

  installPhase = ''
    mkdir -p $out/bin
    find . \
      -type f \
      -executable \
      -maxdepth 1 \
      -exec install --target-directory=$out/bin/ {} +
  '';

  meta = with lib; {
    description = " An assortment of scripts around Git";
    homepage = "https://github.com/da-x/misc-gitology";
    license = [ licenses.bsd2 ];
    maintainers = [ maintainers._9999years ];
  };

  passthru.updateScript = nix-update-script { };
}
