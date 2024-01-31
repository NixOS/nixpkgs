def pre_mutation(context):
    line = context.current_source_line.strip()
    if line.startswith("self.log") or line.startswith("raise") or ".nested" in line:
        context.skip = True
