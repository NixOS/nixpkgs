{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-yRLbe3xl0L/PfRcVB4LA6JeDvLpgUhtKZiAfyB2v/ZE=";
      hash_darwin_aarch64 =
        "sha256-TMreCFF9Lo+9gy7kzZWd9Mjep0CYa3Cxn4kr9BNTdkE=";
      hash_linux = "sha256-rM2usA0zDZ1aXvkbvm+l0xalViEJIxu8ZYZvoTkNiis=";
      version = "123.0.6312.58";
    };
    deps = {
      gn = {
        hash = "sha256-UhdDsq9JyP0efGpAaJ/nLp723BbjM6pkFPcAnQbgMKY=";
        rev = "f99e015ac35f689cfdbf46e4eb174e5d2da78d8e";
        url = "https://gn.googlesource.com/gn";
        version = "2024-01-22";
      };
    };
    hash = "sha256-BzLSwDQrmKavh4s2uOSfP935NnB5+Hw7oD7YDbSWp2g=";
    hash_deb_amd64 = "sha256-SxdYfWhV3ZpiGWmagOM6JUfjAmU9pzFGDQDinXrweas=";
    version = "122.0.6261.128";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        hash = "sha256-UhdDsq9JyP0efGpAaJ/nLp723BbjM6pkFPcAnQbgMKY=";
        rev = "f99e015ac35f689cfdbf46e4eb174e5d2da78d8e";
        url = "https://gn.googlesource.com/gn";
        version = "2024-01-22";
      };
      ungoogled-patches = {
        hash = "sha256-YIJysusNifUPN3Ii2tCUSvHEe63RWlTrTdOt5KBVyK4=";
        rev = "122.0.6261.128-1";
      };
    };
    hash = "sha256-BzLSwDQrmKavh4s2uOSfP935NnB5+Hw7oD7YDbSWp2g=";
    hash_deb_amd64 = "sha256-SxdYfWhV3ZpiGWmagOM6JUfjAmU9pzFGDQDinXrweas=";
    version = "122.0.6261.128";
  };
}
