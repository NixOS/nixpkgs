{ buildGoModule
, fetchFromGitHub
, fetchpatch
, lib
}:

buildGoModule rec {
  pname = "git-remote-ipld";
  version = "unstable-2022-06-21";

  src = fetchFromGitHub {
    owner = "ipfs-shipyard";
    repo = pname;
    rev = "304abe54d48e49b87b40f962749d5a96a2c6edd7";
    hash = "sha256-9DgbRdH+2bFLgTSBdyMGTyns8AjASQAvj1WLlX6nVTU=";
  };

  patches = [
    (fetchpatch {
      name = "fix-nil-shell.patch";
      url = "https://github.com/ipfs-shipyard/git-remote-ipld/commit/2b44cb286bcc601b46d5d1f9e9150e227ab96e47.patch";
      hash = "sha256-eBz9x7z4hEUJRYAIvLvNQvOXuodLeh8gCJ4QdG+TFuY=";
    })
  ];

  # needs IPFS daemon
  doCheck = false;

  vendorHash = "sha256-LpQYi8pqMIiNjDyXiNSEF8kwciK6eQq/yyPsgsArHko=";

  meta = with lib; {
    description = "Git remote helper for the IPFS network using IPLD";
    homepage = "https://github.com/ipfs-shipyard/git-remote-ipld";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
