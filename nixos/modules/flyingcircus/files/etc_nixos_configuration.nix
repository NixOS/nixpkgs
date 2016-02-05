# Hand over to our configuration from the channel
{ modulesPath, ...}:
{
    imports =
        ["${modulesPath}/flyingcircus"];
}
