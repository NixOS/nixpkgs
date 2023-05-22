{ config, lib, pkgs, ... }:
# We do not need Azure Agent,
# see https://docs.microsoft.com/en-us/azure/virtual-machines/linux/no-agent
let
  signal-ready = pkgs.writeShellApplication {
    name = "signal-ready";
    runtimeInputs = with pkgs; [ curl ];
    text = ''
      attempts=1
      until [ "$attempts" -gt 5 ]
      do
          echo "obtaining goal state - attempt $attempts"
          if goalstate=$(curl --fail -v -H "x-ms-agent-name: azure-vm-register" \
                                              -H "Content-Type: text/xml;charset=utf-8" \
                                              -H "x-ms-version: 2012-11-30" \
                                                 "http://168.63.129.16/machine/?comp=goalstate");
          then
             echo "successfully retrieved goal state"
             retrieved_goal_state=true
             break
          fi
          sleep 5
          attempts=$((attempts+1))
      done

      if [ "$retrieved_goal_state" != "true" ]
      then
          echo "failed to obtain goal state - cannot register this VM"
          exit 1
      fi

      container_id=$(grep ContainerId <<< "$goalstate" | sed 's/\s*<\/*ContainerId>//g' | sed 's/\r$//')
      instance_id=$(grep InstanceId <<< "$goalstate" | sed 's/\s*<\/*InstanceId>//g' | sed 's/\r$//')

      ready_doc=$(cat << EOF
      <?xml version="1.0" encoding="utf-8"?>
      <Health xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <GoalStateIncarnation>1</GoalStateIncarnation>
        <Container>
          <ContainerId>$container_id</ContainerId>
          <RoleInstanceList>
            <Role>
              <InstanceId>$instance_id</InstanceId>
              <Health>
                <State>Ready</State>
              </Health>
            </Role>
          </RoleInstanceList>
        </Container>
      </Health>
      EOF
      )

      attempts=1
      until [ "$attempts" -gt 5 ]
      do
          echo "registering with Azure - attempt $attempts"
          if curl --fail -v -H "x-ms-agent-name: azure-vm-register" \
                                   -H "Content-Type: text/xml;charset=utf-8" \
                                   -H "x-ms-version: 2012-11-30" \
                                   -d "$ready_doc" \
                                   "http://168.63.129.16/machine?comp=health";
          then
             echo "successfully register with Azure"
             break
          fi
          sleep 5 # sleep to prevent throttling from wire server
      done
    '';
  };
in {
  # Azure metadata is available as a CD-ROM drive.
  # But only before azure-signal-ready.service have run
  fileSystems."/metadata".device = "/dev/cdrom";

  systemd.services.azure-signal-ready = {
    # TODO: Add enable option. So it can be disabled when azure agent is used
    description = "Report VM ready to Azure ";

    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];

    path = [ signal-ready pkgs.coreutils ];

    unitConfig = {
      ConditionPathExists = "!/var/lib/reported-ready-to-azure";
    };

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      signal-ready
      touch /var/lib/reported-ready-to-azure
    '';
  };
}