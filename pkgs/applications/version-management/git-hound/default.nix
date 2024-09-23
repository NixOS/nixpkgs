{ buildGoModule
, fetchFromGitHub
, fetchpatch
, lib
}:

buildGoModule rec {
  pname = "git-hound";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "tillson";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-W+rYDyRIw4jWWO4UZkUHFq/D/7ZXM+y5vdbclk6S0ro=";
  };

  patches = [
    # https://github.com/tillson/git-hound/pull/66
    (fetchpatch {
      url = "https://github.com/tillson/git-hound/commit/cd8aa19401cfdec9e4d76c1f6eb4d85928ec4b03.patch";
      hash = "sha256-EkdR2KkxxlMLNtKFGpxsQ/msJT5NcMF7irIUcU2WWJY=";
    })
  ];

  # tests fail outside of nix
  doCheck = false;

  vendorHash = "sha256-8teIa083oMXm0SjzMP+mGOVAel1Hbsp3TSMhdvqVbQs=";

  meta = with lib; {
    description = "Reconnaissance tool for GitHub code search";
    longDescription = ''
      GitHound pinpoints exposed API keys and other sensitive information
      across all of GitHub using pattern matching, commit history searching,
      and a unique result scoring system.
    '';
    homepage = "https://github.com/tillson/git-hound";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "git-hound";
  };
}
