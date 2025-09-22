{
  google-protobuf = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fanhdf3vzghma51w1hqpp8s585mwzxgqkwvxj5is4q9j0pgwcs3";
      type = "gem";
    };
    version = "3.25.5";
  };
  pg_query = {
    dependencies = [ "google-protobuf" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15ynrzqsmmbmxib8ri8n9k6z3l6rwd91j7y1mghm33nfgdf9bj8w";
      type = "gem";
    };
    version = "4.2.3";
  };
  sqlint = {
    dependencies = [ "pg_query" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06gljzjhbfvxs85699jr1p7y2j8hhi629kfarad7yjqy7ssl541n";
      type = "gem";
    };
    version = "0.3.0";
  };
}
