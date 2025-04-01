#!/usr/bin/env python3
import json
import os
from pathlib import Path

def format_number(value):
    """Format numbers in a readable way, handling scientific notation."""
    if isinstance(value, float):
        # Handle scientific notation
        if abs(value) < 0.01 or abs(value) >= 1e6:
            # Convert to scientific notation
            # Display the last 5 significant digits
            return f"{value:.5g}"
        else:
            return f"{value}"
    return str(value)

def calculate_percentage_change(before, after):
    """Calculate percentage change between before and after values."""
    if before == 0:
        return "∞" if after > 0 else "0%"

    percent_change = ((after - before) / before) * 100
    return f"{percent_change:+.2f}%"

def get_trend_indicator(percent_change):
    """Return an indicator for the trend (improvement/regression)."""
    if percent_change == "∞" or percent_change == "0%":
        return " "

    # Extract the numeric value from the percentage string
    try:
        value = float(percent_change.replace("%", "").replace("+", ""))
        # Less than 0.1% change is considered neutral
        # We might change this in the future
        # though it only affects where a visual indicator appears
        if abs(value) < 0.1:
            return " "  # (indicator not shown, because minor change)
        if value > 0:
            return "↑"  # (increase)
        else:
            return "↓"  # (decrease in resource usage)
    except ValueError:
        return " "

def main():
    # Get result paths from environment variables
    # Both directories should contain a 'stats.json' file
    before_dir = os.environ.get("BEFORE_DIR")
    after_dir = os.environ.get("AFTER_DIR")

    if not before_dir or not after_dir:
        print("Error: Environment variables 'BEFORE_DIR' and 'AFTER_DIR' must be set.")
        exit(1)

    before_file = Path(before_dir) / "stats.json"
    after_file = Path(after_dir) / "stats.json"

    try:
        with open(before_file, 'r') as f:
            before_data = json.load(f)
        with open(after_file, 'r') as f:
            after_data = json.load(f)
    except FileNotFoundError as e:
        print(f"Error: Could not find stats.json in the directory: {e}")
        exit(1)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON format in stats files: {e}")
        exit(1)

    # Create markdown table
    markdown = "# Performance Metrics Comparison\n\n"
    markdown += "| Metric | Before | After | Change |\n"
    markdown += "|--------|--------|-------|--------|\n"

    # Process only metrics that exist in both files
    common_metrics = sorted(set(before_data.keys()) & set(after_data.keys()))

    # Add the comparison rows to the table
    # common_metrics is a list of alphabetically sorted metric names
    for metric in common_metrics:
        # If the metric is a dictionary, it's a statistical collection
        # Skip metrics that don't have a 'mean' value (they're not statistical collections
        if isinstance(before_data[metric], dict) and 'mean' in before_data[metric] and \
           isinstance(after_data[metric], dict) and 'mean' in after_data[metric]:

            before_value = before_data[metric]["mean"]
            after_value = after_data[metric]["mean"]

            # Format the values
            before_formatted = format_number(before_value)
            after_formatted = format_number(after_value)

            # Calculate percentage change
            percent_change = calculate_percentage_change(before_value, after_value)
            trend = get_trend_indicator(percent_change)

            # Add row to table
            markdown += f"| {metric} | {before_formatted} | {after_formatted} | {trend} {percent_change} |\n"
        elif not isinstance(before_data[metric], dict) and not isinstance(after_data[metric], dict):
            # Handle simple values (not dictionaries)
            before_value = before_data[metric]
            after_value = after_data[metric]

            before_formatted = format_number(before_value)
            after_formatted = format_number(after_value)

            percent_change = calculate_percentage_change(before_value, after_value)
            trend = get_trend_indicator(percent_change)

            markdown += f"| {metric} | {before_formatted} | {after_formatted} | {trend} {percent_change} |\n"

    # Print the markdown table
    print(markdown)


if __name__ == "__main__":
    main()
