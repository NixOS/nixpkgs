{
  runCommand,
  age,
  age-plugin-tpm,
}:
runCommand "age-plugin-tpm-encrypt"
  {
    nativeBuildInputs = [
      age
      age-plugin-tpm
    ];
    # example pubkey from Foxboron/age-plugin-tpm README
    env.AGE_RECIPIENT = "age1tpm1qg86fn5esp30u9h6jy6zvu9gcsvnac09vn8jzjxt8s3qtlcv5h2x287wm36";
  }
  ''
    echo "Hello World" | age --encrypt --armor --recipient "$AGE_RECIPIENT"
    touch $out
  ''
