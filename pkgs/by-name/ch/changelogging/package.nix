{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "changelogging";
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-orTUCBHacD0MQNfhOUWdh9RxT/9YNvgfCHFDr2eNQic=";
  };

  cargoHash = "sha256-aV0Jf/szJq4x6590WPLG8ctB7CR6k+yiR69GcEcbPhI=";

  meta = with lib; {
    description = "Building changelogs from fragments";
    homepage = "https://github.com/nekitdev/${pname}";
    license = licenses.mit;
    maintainers = with maintainers; [ nekitdev ];
    mainProgram = pname;
  };
}
