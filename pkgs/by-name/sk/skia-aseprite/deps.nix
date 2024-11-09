{ fetchgit }:
{
  angle2 = fetchgit {
    url = "https://chromium.googlesource.com/angle/angle.git";
    rev = "8718783526307a3fbb35d4c1ad4e8101262a0d73";
    hash = "sha256-UXYCqn++WCyncwNyuuq8rIkxlB7koMK9Ynx7TRzCIDE=";
  };
  dng_sdk = fetchgit {
    url = "https://android.googlesource.com/platform/external/dng_sdk.git";
    rev = "c8d0c9b1d16bfda56f15165d39e0ffa360a11123";
    hash = "sha256-lTtvBUGaia0jhrxpw7k7NIq2SVyGmBJPCvjIqAQCmNo=";
  };
  piex = fetchgit {
    url = "https://android.googlesource.com/platform/external/piex.git";
    rev = "bb217acdca1cc0c16b704669dd6f91a1b509c406";
    hash = "sha256-IhAfxlu0UmllihBP9wbg7idT8azlbb9arLKUaZ6qNxY=";
  };
  sfntly = fetchgit {
    url = "https://chromium.googlesource.com/external/github.com/googlei18n/sfntly.git";
    rev = "b55ff303ea2f9e26702b514cf6a3196a2e3e2974";
    hash = "sha256-/zp1MsR31HehoC5OAI4RO8QBlm7mldQNiTI7Xr/LJeI=";
  };
}
