{
  lib,
  nodePackages,
}:
nodePackages."@sunodo/cli".overrideAttrs (_: {
  meta = with lib; {
    description = "Sunodo CLI";
    homepage = "https://github.com/sunodo/sunodo";
    license = licenses.asl20;
    maintainers = with maintainers; [ aciceri ];
    mainProgram = "sunodo";
  };
})
