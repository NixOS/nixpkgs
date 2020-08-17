{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gitpert";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "augmentable-dev";
    repo = "gitpert";
    rev = "v${version}";
    sha256 = "11fs74j8ibq9zqmp87j91l7m34iwgh9bwlf7rb68liq6x9d4kj28";
  };

  vendorSha256 = "1n7j3wjbls8xlavv0p9116g4bj0phdicywnk4z2s8zl180m3zqhn";

  meta = with lib; {
    description = "Identify the most relevant git contributors based on commit recency, frequency and impact";
    homepage = "https://github.com/augmentable-dev/gitpert";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
