func main() {
	var err error

  input := os.Args[1]
  ruleSetOutput := "rule-set"

  binary, err := os.ReadFile(input)
	if err != nil {
		panic(err)
	}
  metadata, countryMap, err := parse(binary)
	if err != nil {
		panic(err)
	}
	allCodes := make([]string, 0, len(countryMap))
	for code := range countryMap {
		allCodes = append(allCodes, code)
	}

	writer, err := newWriter(metadata, allCodes)
	if err != nil {
		panic(err)
	}
	err = write(writer, countryMap, "geoip.db", nil)
	if err != nil {
		panic(err)
	}

	writer, err = newWriter(metadata, []string{"cn"})
	if err != nil {
		panic(err)
	}
	err = write(writer, countryMap, "geoip-cn.db", []string{"cn"})
	if err != nil {
		panic(err)
	}

	err = os.MkdirAll(ruleSetOutput, 0o755)
	if err != nil {
		panic(err)
	}
	for countryCode, ipNets := range countryMap {
		var headlessRule option.DefaultHeadlessRule
		headlessRule.IPCIDR = make([]string, 0, len(ipNets))
		for _, cidr := range ipNets {
			headlessRule.IPCIDR = append(headlessRule.IPCIDR, cidr.String())
		}
		var plainRuleSet option.PlainRuleSet
		plainRuleSet.Rules = []option.HeadlessRule{
			{
				Type:           C.RuleTypeDefault,
				DefaultOptions: headlessRule,
			},
		}
		srsPath, _ := filepath.Abs(filepath.Join(ruleSetOutput, "geoip-"+countryCode+".srs"))
		os.Stderr.WriteString("write " + srsPath + "\n")
		outputRuleSet, err := os.Create(srsPath)
		if err != nil {
			panic(err)
		}
		err = srs.Write(outputRuleSet, plainRuleSet)
		if err != nil {
			outputRuleSet.Close()
			panic(err)
		}
		outputRuleSet.Close()
	}
}
