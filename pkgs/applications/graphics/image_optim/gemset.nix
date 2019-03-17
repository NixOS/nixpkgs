{
  exifr = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q2abhiyvgfv23i0izbskjxcqaxiw9bfg6s57qgn4li4yxqpwpfg";
      type = "gem";
    };
    version = "1.3.6";
  };
  fspath = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vjn9sy4hklr2d5wxmj5x1ry31dfq3sjp779wyprb3nbbdmra1sc";
      type = "gem";
    };
    version = "3.1.0";
  };
  image_optim = {
    dependencies = ["exifr" "fspath" "image_size" "in_threads" "progress"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "082w9qcyy9j6m6s2pknfdcik7l2qch4j48axs13m06l4s1hz0dmg";
      type = "gem";
    };
    version = "0.26.3";
  };
  image_size = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bcn7nc6qix3w4sf7xd557lnsgjniqa7qvz7nnznx70m8qfbc7ig";
      type = "gem";
    };
    version = "2.0.0";
  };
  in_threads = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14hqm59sgqi91ag187zwpgwi58xckjkk58m031ghkp0csl8l9mkx";
      type = "gem";
    };
    version = "1.5.1";
  };
  progress = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yrzq4v5sp7cg4nbgqh11k3d1czcllfz98dcdrxrsjxwq5ziiw0p";
      type = "gem";
    };
    version = "3.5.0";
  };
}