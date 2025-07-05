{
  cava,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
}:
cava.overrideAttrs (old: rec {
  pname = "libcava";
  # fork may not be updated when we update upstream
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "LukashonakV";
    repo = "cava";
    tag = version;
    hash = "sha256-9eTDqM+O1tA/3bEfd1apm8LbEcR9CVgELTIspSVPMKM=";
  };

  nativeBuildInputs = old.nativeBuildInputs ++ [
    meson
    ninja
  ];

  # Automatically enable all optional dependencies
  # (instead, Nix sets this option to "enabled" which
  # forces all optional dependencies to be required
  # or disabled individually)
  mesonAutoFeatures = "auto";

  dontVersionCheck = true; # no `bin/cava`
  passthru.updateScript = nix-update-script { };

  meta = old.meta // {
    homepage = "https://github.com/LukashonakV/cava";
    description = "Fork of CAVA to build it as a shared library";
  };
})
