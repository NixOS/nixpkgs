{
  fetchFromGitHub,
  gnu-efi,
  refind,
}:

gnu-efi.overrideAttrs (
  finalAttrs: prevAttrs: {
    version = "3.0.19";
    src = fetchFromGitHub {
      owner = "ncroxon";
      repo = "gnu-efi";
      rev = finalAttrs.version;
      hash = "sha256-xtiKglLXm9m4li/8tqbOsyM6ThwGhyu/g4kw5sC4URY=";
    };
    passthru.tests = {
      inherit refind;
    };
  }
)
