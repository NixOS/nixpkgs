# CIRCT depends on a specific sv-lang revision, so pin it separately from nixpkgs' sv-lang.
{
  sv-lang,
  fetchFromGitHub,
  tomlplusplus,
}:

sv-lang.overrideAttrs (old: {
  src = fetchFromGitHub {
    owner = "MikePopoloski";
    repo = "slang";
    rev = "44dc55f99b9c64971893013e7931e643fbedcf23";
    hash = "sha256-tKse5rV5kHZmCOb8Zb8k4bOw4wN3pDfY5exdpva57bU=";
  };

  cmakeFlags = old.cmakeFlags ++ [
    "-DSLANG_USE_SYSTEM_TOMLPLUSPLUS=ON"
  ];

  propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [
    tomlplusplus
  ];
})
