{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "smag";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "aantn";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Vyd35wYDNI4T7DdqihwpmJOAZGxjnCeWS609o3L+gHM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qOinPZwZqcfQ4gv0Z+sfF53zd4tlEWCczaGGmLL79iE=";

  meta = with lib; {
    description = "Easily create graphs from cli commands and view them in the terminal";
    longDescription = ''
      Easily create graphs from cli commands and view them in the terminal.
      Like the watch command but with a graph of the output.
    '';
    homepage = "https://github.com/aantn/smag";
    license = licenses.mit;
    changelog = "https://github.com/aantn/smag/releases/tag/v${version}";
    mainProgram = "smag";
    maintainers = with maintainers; [ zebreus ];
  };
}
