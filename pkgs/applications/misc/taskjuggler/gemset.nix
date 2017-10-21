{
  "mail" = {
    version = "2.6.3";
    source = {
      type = "gem";
      sha256 = "1nbg60h3cpnys45h7zydxwrl200p7ksvmrbxnwwbpaaf9vnf3znp";
    };
    dependencies = [
      "mime-types"
    ];
  };
  "mime-types" = {
    version = "2.6.1";
    source = {
      type = "gem";
      sha256 = "1vnrvf245ijfyxzjbj9dr6i1hkjbyrh4yj88865wv9bs75axc5jv";
    };
  };
  "taskjuggler" = {
    version = "3.5.0";
    source = {
      type = "gem";
      sha256 = "0r84rlc7a6w7p9nc9mgycbs5h0hq0kzscjq7zj3296xyf0afiwj2";
    };
    dependencies = [
      "mail"
      "term-ansicolor"
    ];
  };
  "term-ansicolor" = {
    version = "1.3.2";
    source = {
      type = "gem";
      sha256 = "0ydbbyjmk5p7fsi55ffnkq79jnfqx65c3nj8d9rpgl6sw85ahyys";
    };
    dependencies = [
      "tins"
    ];
  };
  "tins" = {
    version = "1.6.0";
    source = {
      type = "gem";
      sha256 = "02qarvy17nbwvslfgqam8y6y7479cwmb1a6di9z18hzka4cf90hz";
    };
  };
}
