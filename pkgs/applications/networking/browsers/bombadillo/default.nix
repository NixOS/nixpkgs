{ lib, fetchgit, buildGoModule }:

buildGoModule rec {
  pname = "bombadillo";
  version = "2.3.3";

  src = fetchgit {
    url = "https://tildegit.org/sloum/bombadillo.git";
    rev = version;
    sha256 = "02w6h44sxzmk3bkdidl8xla0i9rwwpdqljnvcbydx5kyixycmg0q";
  };

  vendorSha256 = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";

  meta = with lib; {
    description = "Non-web client for the terminal, supporting Gopher, Gemini and more";
    homepage = "https://bombadillo.colorfield.space/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ehmry ];
  };
}
