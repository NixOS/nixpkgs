{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "impala";
<<<<<<< HEAD
  version = "0.6.0";
=======
  version = "0.4.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "impala";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-FU/8g2zTTHm3Sdbxt9761Z+a0zaJMdAMdHrJIwjUrYs=";
  };

  cargoHash = "sha256-dpTLVlDxc9eK7GwbweODoJlrBZeYwVcv1fQ2UtYbg7k=";
=======
    hash = "sha256-CRnGycN2juXXNI1LhAH5HQbmXYatBZ0GxYKYgb5SBSE=";
  };

  cargoHash = "sha256-fBeSbJdFwT/ZwK2FTJQtZakKqMiAICMY2rkbNnYOGzU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "TUI for managing wifi";
    homepage = "https://github.com/pythops/impala";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
      nydragon
      bridgesense
    ];
=======
    maintainers = [ lib.maintainers.nydragon ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
