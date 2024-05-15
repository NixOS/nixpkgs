{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-ahwPSPoB2h6Zq4ePbvSmYs3WNc+MpBXQYyYLf0ZS3ss=";
      hash_darwin_aarch64 =
        "sha256-NVqr/i4S4XP+z0+YT6CuDnmyN4GtS6ttyJDOQ05KB+0=";
      hash_linux = "sha256-PKuhfBw5FblCUQ60yeQC0McvYu7gPfwwIW1ysN/MwVA=";
      version = "125.0.6422.60";
    };
    deps = {
      gn = {
        hash = "sha256-aEL1kIhgPAFqdb174dG093HoLhCJ07O1Kpqfu7r14wQ=";
        rev = "22581fb46c0c0c9530caa67149ee4dd8811063cf";
        url = "https://gn.googlesource.com/gn";
        version = "2024-03-14";
      };
    };
    hash = "sha256-IeIWk4y1dufEnhxqvZbQlFVD8dsoceysiEHqJ2G4Oz8=";
    version = "124.0.6367.207";
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
        hash = "sha256-7Z9j+meVRZYLmreCzHlJe71E9kj5YJ4rrfpQ/deNTpM=";
        rev = "124.0.6367.207-1";
      };
    };
    hash = "sha256-IeIWk4y1dufEnhxqvZbQlFVD8dsoceysiEHqJ2G4Oz8=";
    version = "124.0.6367.207";
  };
}
