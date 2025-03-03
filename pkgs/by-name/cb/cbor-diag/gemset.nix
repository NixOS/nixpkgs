{
  cbor-canonical = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fhj51s5d9b9spw096sb0p92bgilw9hrsay383563dh913j2jn11";
      type = "gem";
    };
    version = "0.1.2";
  };
  cbor-deterministic = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1w1mg4mn1dhlxlbijxpzja8m8ggrjs0hzkzvnaazw9zm1ji6dpba";
      type = "gem";
    };
    version = "0.1.3";
  };
  cbor-diag = {
    dependencies = [
      "cbor-canonical"
      "cbor-deterministic"
      "cbor-packed"
      "json_pure"
      "neatjson"
      "treetop"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12gicnz857iin9lhbrigyqz4v8fan9lq4sd56rfcb2c7a8azvmz9";
      type = "gem";
    };
    version = "0.8.8";
  };
  cbor-packed = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1dijyj7rivi39h34f32fx7k4xvngldf569i0372n1z6w01nv761l";
      type = "gem";
    };
    version = "0.1.5";
  };
  json_pure = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13b4dminf6znfwvj8d61w6dar9zrxnndrmiig19adbliv0haxmlr";
      type = "gem";
    };
    version = "2.7.2";
  };
  neatjson = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wm1lq8yl6rzysh3wg6fa55w5534k6ppiz0qb7jyvdy582mk5i0s";
      type = "gem";
    };
    version = "0.10.5";
  };
  polyglot = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bqnxwyip623d8pr29rg6m8r0hdg08fpr2yb74f46rn1wgsnxmjr";
      type = "gem";
    };
    version = "0.3.5";
  };
  treetop = {
    dependencies = [ "polyglot" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0adc8qblz8ii668r3rksjx83p675iryh52rvdvysimx2hkbasj7d";
      type = "gem";
    };
    version = "1.6.12";
  };
}
