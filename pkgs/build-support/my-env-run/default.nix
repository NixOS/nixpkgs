{ writeScript, bash, myEnvFun }: args:

let env = myEnvFun args; in writeScript "envrun-${args.name}" ''
  #!${bash}/bin/bash
  ${env}/bin/load-env-${args.name}
''
