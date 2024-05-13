{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-jnWmH6MzqZzzIAblvJFv5jKFJ2LILyGy+eOqb6sWmWc=";
      hash_darwin_aarch64 =
        "sha256-FO0kncAPj/cBwlGN2RdFGR7Bn5pKzTRlf2IQ422mm5c=";
      hash_linux = "sha256-3khPV+WPcYHrlGNFXhmRrja2+wWsr77BVgHLbSe0IF8=";
      version = "124.0.6367.201";
    };
    deps = {
      gn = {
        hash = "sha256-aEL1kIhgPAFqdb174dG093HoLhCJ07O1Kpqfu7r14wQ=";
        rev = "22581fb46c0c0c9530caa67149ee4dd8811063cf";
        url = "https://gn.googlesource.com/gn";
        version = "2024-03-14";
      };
    };
    hash = "sha256-nSI+tkJxOedMtYgtiqW37v0ZjgxxU5o/0sH9bPAchBg=";
    version = "124.0.6367.201";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        hash = "sha256-aEL1kIhgPAFqdb174dG093HoLhCJ07O1Kpqfu7r14wQ=";
        rev = "22581fb46c0c0c9530caa67149ee4dd8811063cf";
        url = "https://gn.googlesource.com/gn";
        version = "2024-03-14";
      };
      ungoogled-patches = {
        hash = "sha256-fy4SydGRRyDhJZ7IADG54+rGWh2i+2SrSkuCglphhm8=";
        rev = "124.0.6367.201-1";
      };
    };
    hash = "sha256-nSI+tkJxOedMtYgtiqW37v0ZjgxxU5o/0sH9bPAchBg=";
    version = "124.0.6367.201";
  };
}
