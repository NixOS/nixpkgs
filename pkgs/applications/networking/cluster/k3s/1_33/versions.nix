{
<<<<<<< HEAD
  k3sVersion = "1.33.6+k3s1";
  k3sCommit = "b5847677be5afdc431f70afec6780679c3845d16";
  k3sRepoSha256 = "0pm8x121pb6pyn9rq9c5pbr7y293rzyp0q3c5mc1gb4glqwx7f8g";
  k3sVendorHash = "sha256-Cjacx5i1ahZ9RBXBTsUtmNDyyofw1fedpExTHuU8grA=";
=======
  k3sVersion = "1.33.5+k3s1";
  k3sCommit = "fab4a5c3de46748494cf7ad5dccc89b213965b08";
  k3sRepoSha256 = "0c0phxnx09gainay4cgbcc2j1ddci73a9i0q92zf32whkbp06112";
  k3sVendorHash = "sha256-v+tfVL9sDyiDRB3/IDDfyDekFAdjdUtTTChu6l5Qvg0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.0";
  k3sRootSha256 = "008n8xx7x36y9y4r24hx39xagf1dxbp3pqq2j53s9zkaiqc62hd0";
<<<<<<< HEAD
  k3sCNIVersion = "1.8.0-k3s1";
  k3sCNISha256 = "04xig5spp81l81781ixmk99ghiz8lk0p16zhcbja5mslfdjmc7vg";
  containerdVersion = "2.1.5-k3s1.33";
  containerdSha256 = "15iw6px3710rlsx7j933i07qd4a2r7caagfjbhhfcp33m9k19v7h";
=======
  k3sCNIVersion = "1.7.1-k3s1";
  k3sCNISha256 = "0k1qfmsi5bqgwd5ap8ndimw09hsxn0cqf4m5ad5a4mgl6akw6dqz";
  containerdVersion = "2.1.4-k3s1";
  containerdSha256 = "0fg9py52hac5bdmrabvkcpc1aawxl5xc0ij9zx964qkkc7fa19ca";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  criCtlVersion = "1.33.0-k3s2";
}
