func main() {
	outputFile, err := os.Create("geosite.db")
	if err != nil {
		panic(err)
	}
	defer outputFile.Close()
	vData, err := ioutil.ReadFile("@geosite_data@")
	if err != nil {
		panic(err)
	}
	domainMap, err := parse(vData)
	if err != nil {
		panic(err)
	}
	err = geosite.Write(outputFile, domainMap)
	if err != nil {
		panic(err)
	}

	ruleSetOutput := "rule-set"
	err = os.MkdirAll(ruleSetOutput, 0o755)
	if err != nil {
		panic(err)
	}
	for code, domains := range domainMap {
		var headlessRule option.DefaultHeadlessRule
		defaultRule := geosite.Compile(domains)
		headlessRule.Domain = defaultRule.Domain
		headlessRule.DomainSuffix = defaultRule.DomainSuffix
		headlessRule.DomainKeyword = defaultRule.DomainKeyword
		headlessRule.DomainRegex = defaultRule.DomainRegex
		var plainRuleSet option.PlainRuleSet
		plainRuleSet.Rules = []option.HeadlessRule{
			{
				Type:           C.RuleTypeDefault,
				DefaultOptions: headlessRule,
			},
		}
		srsPath, _ := filepath.Abs(filepath.Join(ruleSetOutput, "geosite-"+code+".srs"))
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
