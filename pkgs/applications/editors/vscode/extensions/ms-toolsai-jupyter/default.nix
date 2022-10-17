{ lib, vscode-utils, jq, moreutils }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;

in buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "jupyter";
    publisher = "ms-toolsai";
    version = "2022.5.1001411044";
    sha256 = "0z6i7a5sba42yc2inp3yvw6lm6m0kings2iv18h4d6zyhm2lb61p";
  };

  nativeBuildInputs = [
    jq
    moreutils
  ];

  postPatch = ''
    # Patch 'packages.json' so that the expected '__metadata' field exists.
    # This works around observed extension load failure on vscode's attempt
    # to rewrite 'packages.json' with this new information.
    print_jq_query() {
        cat <<"EOF"
    .__metadata = {
      "id": "6c2f1801-1e7f-45b2-9b5c-7782f1e076e8",
      "publisherId": "ac8eb7c9-3e59-4b39-8040-f0484d8170ce",
      "publisherDisplayName": "Microsoft",
      "installedTimestamp": 0
    }
    EOF
    }
    jq "$(print_jq_query)" ./package.json | sponge ./package.json
  '';

  meta = with lib; {
    description = "Jupyter extension for vscode";
    homepage = "https://github.com/microsoft/vscode-jupyter";
    license = licenses.mit;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
