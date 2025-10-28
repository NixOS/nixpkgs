{
  k3sVersion = "1.34.1+k3s1";
  k3sCommit = "24fc436e6ea59c56ebc37727baa4e6c9a201ee01";
  k3sRepoSha256 = "0fjkjsmig7xdn1filph2wbp69jva0jdkv8ax68wymvbqq4rn3s0k";
  k3sVendorHash = "sha256-87YMUWhwfFwm5bzcL42b7JFJbVWsoRtubH4jjYH/7mc=";
  chartVersions = import ./chart-versions.nix;
  imagesVersions = builtins.fromJSON (builtins.readFile ./images-versions.json);
  k3sRootVersion = "0.15.0";
  k3sRootSha256 = "008n8xx7x36y9y4r24hx39xagf1dxbp3pqq2j53s9zkaiqc62hd0";
  k3sCNIVersion = "1.7.1-k3s1";
  k3sCNISha256 = "0k1qfmsi5bqgwd5ap8ndimw09hsxn0cqf4m5ad5a4mgl6akw6dqz";
  containerdVersion = "2.1.4-k3s2";
  containerdSha256 = "18z6i6mzvllhglarsc6npn4k0m4akg7wm1rqc4a926dag47mgh8j";
  criCtlVersion = "1.34.0-k3s2";
}
