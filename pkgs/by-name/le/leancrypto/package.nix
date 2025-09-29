{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "leancrypto";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "smuellerDD";
    repo = "leancrypto";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tTbjYljI2XRrmVdHyEn6knQV/HDPwBUR3O6OFc6RBPA=";
  };

  mesonFlags = [
    (lib.mesonEnable "apps" false)
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  prePatch = ''
    patchShebangs addon/*.sh apps/tests/*.sh
  '';

  # activate on version bump, then deactivate (long duration)
  doCheck = false;

  meta = with lib; {
    description = "Lean cryptographic library usable for bare-metal environments";
    longDescription = ''
      leancrypto offers a lean and versatile cryptographic library
      building on Post Quantum Cryptography.
    '';
    homepage = "https://github.com/smuellerDD/leancrypto";
    changelog = "https://github.com/smuellerDD/leancrypto/blob/master/CHANGES.md";
    license = [
      licenses.bsd3
      licenses.gpl2
    ];
    maintainers = [ maintainers.thillux ];
    platforms = platforms.all;
  };
})
