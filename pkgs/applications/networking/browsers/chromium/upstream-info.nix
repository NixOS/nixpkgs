{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-iv370BYH8HobUxeYbsV4/A6JyZG2feEuVbJCLVZc3Og=";
      hash_darwin_aarch64 =
        "sha256-Gc0OXG7dx5Mvy0aAsnqVIJtPFK8OYmFr8Ofy+UXacM4=";
      hash_linux = "sha256-ZcN/v7co08aRWM88s93nBU/FLEfE7JGf/hEH0tk3qy8=";
      version = "122.0.6261.94";
    };
    deps = {
      gn = {
        hash = "sha256-UhdDsq9JyP0efGpAaJ/nLp723BbjM6pkFPcAnQbgMKY=";
        rev = "f99e015ac35f689cfdbf46e4eb174e5d2da78d8e";
        url = "https://gn.googlesource.com/gn";
        version = "2024-01-22";
      };
    };
    hash = "sha256-7fIs8qQon9L0iNmM/cHuyqtVm09qf7L4j9qb6KSbw2w=";
    hash_deb_amd64 = "sha256-hOm7YZ9ya/SmwKhj6uIPkdgIDv5bIbss398szBYHuXk=";
    version = "122.0.6261.94";
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
        hash = "sha256-vqiizzSVWV2/iADPac8qgfdZcbunc0QgMqN15NwJ9js=";
        rev = "122.0.6261.94-1";
      };
    };
    hash = "sha256-7fIs8qQon9L0iNmM/cHuyqtVm09qf7L4j9qb6KSbw2w=";
    hash_deb_amd64 = "sha256-hOm7YZ9ya/SmwKhj6uIPkdgIDv5bIbss398szBYHuXk=";
    version = "122.0.6261.94";
  };
}
